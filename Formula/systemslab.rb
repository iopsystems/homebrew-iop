# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitHubGitDownloadStrategy
  def initialize(url, name, version, **meta)
    super
  end

  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:      SystemsLabDownloadStrategy,
    tag:        "v0.0.95",
    revision:   "34c4ddd7b75bc1773ed1503c3c6498d5de7279d1",
    submodules: false
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.94"
    sha256 cellar: :any,                 arm64_ventura: "9c3b0a2a70bc69ef324c5fcb16fa003cf7cd6841533aee2787c6957d16ce82e1"
    sha256 cellar: :any,                 ventura:       "1e2f7737863eef7bf790f5698f83cd754e86980c2afc587bff21c25050e8c317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9974482441fb9115bc5dff3f02dee209cafaf3b38e468d2bd8b0640f5ab106"
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
