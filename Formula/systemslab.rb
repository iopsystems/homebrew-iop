# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.89",
    revision: "53e08536e181690ef14755b82e87c64ac647e788"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.89"
    sha256 cellar: :any,                 arm64_ventura: "8dc7550ad6aa8d1e2ed40b73f64479fb458f5ba0373b6e3d80a45d0bb8d13649"
    sha256 cellar: :any,                 ventura:       "5ec1c76f0226dfc97e7db18dd142ab2da7a447fb8fbcd6350a1f8e0bf156e553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b28516a4b8b35328077af01d56539b0f40e29033388e0db0f39c46851bf2f8a"
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
