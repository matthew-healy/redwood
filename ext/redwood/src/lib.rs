use int::IntoMagnusError;
use magnus::{Module, Object};

/// Exposes the top-level Cedar module to Ruby.
#[magnus::init]
fn init(ruby: &magnus::Ruby) -> Result<(), magnus::Error> {
    let cedar = ruby.define_module("Cedar")?;

    let policy_set = cedar.define_class("PolicySet", ruby.class_object())?;
    policy_set.define_singleton_method("new", magnus::function!(PolicySet::new, 1))?;
    policy_set.define_method("authorized?", magnus::method!(PolicySet::is_authorized, 3))?;

    Ok(())
}

#[magnus::wrap(class = "Cedar::PolicySet", free_immediately, size)]
struct PolicySet(int::PolicySet);

impl PolicySet {
    fn new(ruby: &magnus::Ruby, policy_str: String) -> Result<Self, magnus::Error> {
        Ok(Self(
            int::PolicySet::new(policy_str).map_err(|e| e.into_magnus_error(ruby))?,
        ))
    }

    fn is_authorized(
        ruby: &magnus::Ruby,
        rb_self: &Self,
        principal: String,
        action: String,
        resource: String,
    ) -> Result<bool, magnus::Error> {
        rb_self
            .0
            .is_authorized(principal, action, resource)
            .map_err(|e| e.into_magnus_error(ruby))
    }
}

/// internal module containing the meat of the integration with cedar. largely
/// exists to avoid having to pass `magnus::Ruby` around. as such, uses a custom
/// error type which can be converted to `magnus::Error` when provided with
/// access to ruby.
mod int {
    use std::str::FromStr;

    use cedar_policy as cedar;

    use cedar_policy_validator as cedar_validator;

    pub trait IntoMagnusError {
        fn into_magnus_error(self, ruby: &magnus::Ruby) -> magnus::Error;
    }

    pub enum Error {
        Parse(cedar::ParseErrors),
        RequestValidation(cedar_validator::RequestValidationError),
    }

    impl From<cedar::ParseErrors> for Error {
        fn from(e: cedar::ParseErrors) -> Self {
            Self::Parse(e)
        }
    }

    impl From<cedar_validator::RequestValidationError> for Error {
        fn from(e: cedar_validator::RequestValidationError) -> Self {
            Self::RequestValidation(e)
        }
    }

    impl IntoMagnusError for Error {
        fn into_magnus_error(self, ruby: &magnus::Ruby) -> magnus::Error {
            match self {
                Error::Parse(parse_errs) => magnus::Error::new(
                    ruby.exception_arg_error(),
                    format!("Failed to parse: {}", parse_errs),
                ),
                Error::RequestValidation(validation_err) => magnus::Error::new(
                    ruby.exception_arg_error(),
                    format!("Request validation failed: {}", validation_err),
                ),
            }
        }
    }

    type Result<T> = std::result::Result<T, Error>;

    pub struct PolicySet(cedar::PolicySet);

    impl PolicySet {
        pub fn new(policy_str: String) -> Result<Self> {
            let underlying =
                cedar::PolicySet::from_str(policy_str.as_str()).map_err(Error::Parse)?;
            Ok(Self(underlying))
        }

        pub fn is_authorized(
            &self,
            principal: String,
            action: String,
            resource: String,
        ) -> Result<bool> {
            let principal = cedar::EntityUid::from_str(&principal).map_err(Error::Parse)?;
            let action = cedar::EntityUid::from_str(&action).map_err(Error::Parse)?;
            let resource = cedar::EntityUid::from_str(&resource).map_err(Error::Parse)?;

            let request = cedar::Request::new(
                Some(principal),
                Some(action),
                Some(resource),
                cedar::Context::empty(),
                None,
            )?;

            let authorizer = cedar::Authorizer::new();
            let result = authorizer.is_authorized(&request, &self.0, &cedar::Entities::empty());

            Ok(match result.decision() {
                cedar::Decision::Allow => true,
                cedar::Decision::Deny => false,
            })
        }
    }
}
