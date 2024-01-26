# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.64",
    revision: "41324bd58204c0d947c07b95a3d43f8d5b4fbd48"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.63"
    sha256 cellar: :any,                 arm64_ventura: "0b46a5d9b5c0a81ecea4c6df3451dbed94f895695f7e6f49a2f11b997aa37c6d"
    sha256 cellar: :any,                 ventura:       "fa2a579cb1f13d6177c0b80f1686745b31b6ec2ac577043c56b8e45a2d7018ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58ff0d14a8cffdbb04241d3101d4fec87f796dbbc4ce6e79b35c2cac7011055"
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
