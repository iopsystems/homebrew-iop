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
    tag:      "v133.0.0",
    revision: "4fe676b7f76c389e8414ea74a4b1c8c0278b859e"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-132.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "3adaf419756295a345b5b01b83febded4c4fd2cfae04d5e2b653100158be2881"
    sha256 cellar: :any,                 arm64_sonoma:  "dfb2e4800facab78edd5a7bce5030412be721c10d1d0f4b7d5500855e186450f"
    sha256 cellar: :any,                 arm64_ventura: "8f0d7a2715bf45699c281ff03ed8f7683e67b992dd05949e9cc98547b1d74634"
    sha256 cellar: :any,                 ventura:       "1f94d119f17bfaef9afc03efd1de051c1f0dfe5aaadf9df25be000ab5b2af7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4023e78985bbd7258a4a77be81e7199f113732645f82b7a877ac3b02a3e25568"
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
