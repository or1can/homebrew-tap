class Ratect < Formula
  desc "The forward-looking Ratect CLI, free to diverge from Batect's interface"
  homepage "https://github.com/or1can/ratect"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.13.0/ratect-aarch64-apple-darwin.tar.xz"
      sha256 "6ee1f5d9b232d850d6ceee6fd8e59f865dfd355d3fec2f8a22ce4bbb82feb295"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.13.0/ratect-x86_64-apple-darwin.tar.xz"
      sha256 "2a8d15ec955a09c554ff6f3f01d9f2526bb27378a6c497a9acf629e3d0a27ce1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.13.0/ratect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "919fb15e33a4f7056dc4f5a51e5bcab2424922f3b31d7e7638676f578b4f0b4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.13.0/ratect-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac14add2f6075362e607262e90e09a16288eb3350f88475f22201b6aa30a5bbf"
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
