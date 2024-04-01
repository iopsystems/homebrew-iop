# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.79",
    revision: "28252e39c45d824bd5bc3ea2817324afc9fc2b96"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.79"
    sha256 cellar: :any,                 arm64_ventura: "3112cda79dbff248af916e531ea32c3bbabf5386a1ab3b62173714ee04b96829"
    sha256 cellar: :any,                 ventura:       "698935b02e84f36fcde3d25c6671bf5d0c6b7e4919dffe87247b90fdbf59a187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe247ed1e08f9b1e761c7186711f987a24e881388eabafcd2e2b52550ec4d61"
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
