# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:    "v0.0.61"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.61"
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura: "84c497ce5526c31f944a51529ebb9d4c2d2e27399a53622dbb50ffb381b7f293"
    sha256 cellar: :any,                 ventura:       "7ac72aecb3bd938315b3846e2a39c63cfe4941a8dfeb4de397b3330b89a6a129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14029bb1d9efa3cac375f46455d5e7df3dec401077036e8d134c6c491d57da4"
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
