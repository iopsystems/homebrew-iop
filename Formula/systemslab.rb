# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.76",
    revision: "ee6ae6592a8b60a0bf0e30a4144109ffe8942179"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.76"
    sha256 cellar: :any,                 arm64_ventura: "2ef290a8b942209cdd1466914f639cceb25b1c4e2f488e18314104709ff31cd3"
    sha256 cellar: :any,                 ventura:       "28e5201fe015dbae15d9003ff3097abbaa931e732af92abdf1212cfccd1cfc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35d3b3d4bf8d74baf7d8016ed3785d1ab882b1bf810ae08347af646f5214af4"
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
