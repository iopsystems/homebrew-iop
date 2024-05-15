# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.88",
    revision: "27960b8b90010b2965f942322f56c2d9978dceda"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.82"
    sha256 cellar: :any,                 arm64_ventura: "c7511529e0691e86defe853a28592d5ffde757035c96e56c2f907c2523051cf0"
    sha256 cellar: :any,                 ventura:       "fc1acb6888465f794bd68601f8cc080d336e6cec12a1f5e553faad03614eb8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d446ab0bc210a49b05cfdd64db8deb4d50c452db31ce67835a19f6a1cf41a62"
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
