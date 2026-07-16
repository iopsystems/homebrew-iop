# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "d2964e02282873d6f00ef4e5a0924324105e3056cdaeb58bccd5d7380c1ddb80"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.17.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebeda9f08279474ef58840e5f2b035d7b7c8de8883ea13e3caac0e59e0eca23b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8e84a76d1c80ab29ab148d0a3c93dc2fadea8fb958fa2f7f31bb9a200bbd90"
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
