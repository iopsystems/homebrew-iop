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
    tag:      "v0.0.105",
    revision: "ef377dcd628114be24c62a20dadd00409e8bdf21"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c13616613d7ba87e4b3adef87166d83c5955c0af0ce72107663c53715adb1df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3845059cd45ece44791f02dbc8c1a752a4ee1a1fc4b1459b9e5f456f0811e13"
    sha256 cellar: :any_skip_relocation, ventura:       "726888201794297b8abbaf3be7738e1b532c71d2004400efa9238ce684477313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43edc2d67e91527f2d91c2c53efc2b7b275abec9ac7db576cbec10a3189e102"
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
