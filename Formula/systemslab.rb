# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:    "v0.0.61"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.61"
    sha256 cellar: :any,                 ventura:      "067193ecb7fc8748e2fa39d6f23edf777634b4cd2a91ce5a23274f93a0d8c993"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad2912194b9f9facace805490813469dc8b2c865e2a62589cbc0d1acef57ec07"
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
