# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.73",
    revision: "47ddd207400b8bc9141f18f812798f9b77d2f9eb"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.71"
    sha256 cellar: :any,                 arm64_ventura: "6a1a3eb4b4cf5630b43caf50dcdc5286c63a9d692867e33c384e4c7675e4840e"
    sha256 cellar: :any,                 ventura:       "962976bb96f149d5a4467b277e4cc65df3e8eed811cc9300c87d2df42cd1be6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45b83a8f9d1fc11fa213cfb2b4c97c1221056cf4453921a5c0f8fd6aa647b78"
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
