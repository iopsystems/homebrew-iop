# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.78",
    revision: "bae5c2847d7c96daebb931dd95ec07ab046868f6"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.77"
    sha256 cellar: :any,                 arm64_ventura: "dc1b48ff33548b86df27d3823f407558e6482a981219f4559c11cdf7458fa91d"
    sha256 cellar: :any,                 ventura:       "6a39ef80d7188a708f314cab909f1c9f30ed9b2014c45de2ef567232c4465bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1db83c536673e3e20f9010abac467903855f45f9c366cc459f6a4082a74cc48"
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
