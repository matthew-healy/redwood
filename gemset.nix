{
  power_assert = {
    groups = [ "default" "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y2c5mvkq7zc5vh4ijs1wc9hc0yn4mwsbrjch34jf11pcz116pnd";
      type = "gem";
    };
    version = "2.0.3";
  };
  rake = {
    groups = [ "default" "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ilr853hawi09626axx0mps4rkkmxcs54mapz9jnqvpnlwd3wsmy";
      type = "gem";
    };
    version = "13.1.0";
  };
  rake-compiler = {
    dependencies = [ "rake" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vhdkwblhzp4wp1jh95qiibly2zsnmg3659r6d5xp1mzgd9ghxji";
      type = "gem";
    };
    version = "1.2.7";
  };
  rb_sys = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0khc9iqwinw5wh7ig50kxw5gbbcf86dq7nyh6i0mq2c9rh80mrsv";
      type = "gem";
    };
    version = "0.9.88";
  };
  redwood = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "0.1.0";
  };
  test-unit = {
    dependencies = [ "power_assert" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fb0ya3w6cwl1xnvilggdhr223jn5az1jrhd7x551jlh77181r1w";
      type = "gem";
    };
    version = "3.6.2";
  };
}
