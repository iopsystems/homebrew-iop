# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "12a23235223b8d967f1a987e3c7ace3a8af2e2fcaaebc97c16cee6931aa2849e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02e8bfe6f34908a0d9bb56a007d5117a1b23951e352b4bfe091b5dbb3b8afbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44286542a5f76dff7d4059c22baa33a4bc3ac31b5e285fb96c8ebbdca46b9d6d"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
