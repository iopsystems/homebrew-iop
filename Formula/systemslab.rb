# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.65",
    revision: "b6c2a6f659942b27ae8e4849e93b74def3e6b083"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.65"
    sha256 cellar: :any,                 arm64_ventura: "b9c4038ca50f36d734b8077276e677aa66456fc0e0b6cb593d3682fa44b2e6e9"
    sha256 cellar: :any,                 ventura:       "7e2e2aaf4532738d3b0cfa1790208f26554fafeee79141a4dc31df474ad6f6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2005771d99abc807efdfb59daab010b8046582dda57ae74c26deaa93ed23ab99"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl"
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
