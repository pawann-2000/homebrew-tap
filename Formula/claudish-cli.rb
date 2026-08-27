class ClaudishCli < Formula
  desc "Translate between English and Claudish with tiny ProgramAsWeights functions"
  homepage "https://github.com/pawann-2000/claudish-cli"
  url "https://github.com/pawann-2000/claudish-cli/archive/refs/tags/v0.1.0-Initial-release.tar.gz"
  sha256 "aa230ff5d70d040c504267d31742ae0deface6ae72e3fbb1fa6fa01369c7e877"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  def install
    # bindgen (via llama-cpp-sys-2) needs libclang; macOS finds it through the CLT.
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudish --version")
    # Real translation downloads a ~600 MB model; exercise the CLI's input path instead.
    assert_match "no input", shell_output("#{bin}/claudish to-english </dev/null 2>&1", 1)
  end
end
