# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.91",
    revision: "4d99ee2717cdc406132eeac603308e5f94cd3828"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.90"
    sha256 cellar: :any,                 arm64_ventura: "74b6a1d08762c758c2f364de3864c897354aaa8f0b56048bf6f6c0ad337ccb48"
    sha256 cellar: :any,                 ventura:       "abee5a9295a96f10f3bd069d3d097a19c9daa0883fe79b5e7464b5c7c496e4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3237019922999580786b998be657482b1140ee8e050334305dbd9f99d7faee8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl@3"
  depends_on "xz"

  def install
    system "cargo", "install",
      "--bin", "systemslab",
      "--path", "crates/cli",
      "--profile", "prod",
      "--locked",
      "--root", prefix

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
  end

  test do
    content = <<-EOM
      local systemslab = import "systemslab.libsonnet";

      {
        name: 'test experiment',
        jobs: {
          test_job: {
            steps: [
              systemslab.bash('true')
            ]
          }
        }
      }
    EOM

    File.write("test.jsonnet", content)

    system "#{bin}/systemslab", "evaluate", "test.jsonnet"
  end
end
