# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "96eb79313aefb81da9ba721f180d540f146022a820156d8b83a3605f4c48714e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.18.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a74faaeda862fc237319857cd19c87584c7052b5044d573245217c4f32ff487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd3c785558780311059b84c4eb9728acda39325da5d22603d07bd146fd5427a"
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
