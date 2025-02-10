# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v0.0.116",
    revision: "037f8b873438274678a0872e08e298e4e3ec11e7"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6713c92e01b1188879dee625f4007181b786baeee91a640bf1b8ecd1555129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73c8042be392a8a9ecd2bbbf40ddda8cdbe0aed78c59a778857f29a7466d5981"
    sha256 cellar: :any_skip_relocation, ventura:       "462079ab7383be0cac51621b79cbf26be6cc267d6f7919a03f748eec144971c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992dd819921e5e313d78336189d49151cb3f67398f7d5e15435a5e898b17e9ab"
  end

  depends_on "go" => :build
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

    system prefix/"bin"/"systemslab", "completions", "bash", "-o", "systemslab"
    system prefix/"bin"/"systemslab", "completions", "fish", "-o", "systemslab.fish"
    system prefix/"bin"/"systemslab", "completions", "zsh", "-o", "_systemslab"

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
    bash_completion.install "systemslab"
    fish_completion.install "systemslab.fish"
    zsh_completion.install "_systemslab"
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
