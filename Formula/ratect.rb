class Ratect < Formula
  desc "The forward-looking Ratect CLI, free to diverge from Batect's interface"
  homepage "https://github.com/or1can/ratect"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.10.0/ratect-aarch64-apple-darwin.tar.xz"
      sha256 "25e93410b593e61065851ad0426c6ac5ffb9f4ff346ea9615c54bed7df9610ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.10.0/ratect-x86_64-apple-darwin.tar.xz"
      sha256 "eb864693b2c22e5f2b2abb8f4390cb09d19502b5296048e479fb3eff93d3c925"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.10.0/ratect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "47f7f669385dc8be94b8e13aee62a3205aa6999c014a978a167e067099ae795f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.10.0/ratect-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c13b90916e98783e1313938d06bd5a617aff09d0fb5dc03e94fa90f4751756e"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
