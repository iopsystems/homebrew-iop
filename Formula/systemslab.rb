# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.89",
    revision: "53e08536e181690ef14755b82e87c64ac647e788"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.88"
    sha256 cellar: :any,                 arm64_ventura: "14501b127bf31e72bed4eb4a42a8d094f6faa905c428b11dd28de19b16877caf"
    sha256 cellar: :any,                 ventura:       "cfe540cf758da0fa1fd3ced6ef04ccc793a0250d6b0f4e24709101ada5cf6499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0d9da1c8a0f2839358d6439ccf0126a4fc5c0e20972c96cf94548de04e78b1"
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
