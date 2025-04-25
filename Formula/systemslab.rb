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
    tag:      "v127.0.0",
    revision: "b1f25fb1f218036647f050f52b00800d2a1fd1f5"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-127.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f724284ba6ecd0af3505c400e4067ab88c64adde29e90eaafd12ef4a4c184d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a05b213fdafdf0c3c88ba2f1b04495507d758422308b90e335ce70567fa5df1"
    sha256 cellar: :any_skip_relocation, ventura:       "f6f1d07470cc81607b217cf69f34d13c9ea06daa56a55cf8cd373f036a14f35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e189749f0a18ab34cbaf1e2121f6904850f3bc8ab7c2e424302f01da099330a7"
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
