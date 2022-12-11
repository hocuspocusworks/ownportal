const media = {
  visible: false,
  play(url) {
    this._playSource(url)
  },
  _playSource(url) {
    if (url === null) {
      return
    }

    let player = document.getElementById('mediaPlayer')

    player.classList.remove('d-none')
    player.pause()
    player.setAttribute('src', url)
    player.load()
    player.play()
  }
}

export default media
