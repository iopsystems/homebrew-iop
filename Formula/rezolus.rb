# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "46abfbe61e4426528a40b1d71eb1730f900504407eb08aada3dda2991573c4cc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.16.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e15b2e203b3bbb0aa09a538fec78d353faa96507d1da31ae9b49b1c8679e021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9287c7abaf1ea0677661e391186dde475b5d836c628937cb5a706c152a1992d2"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = formula_opt_bin("llvm")/"clang"
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
