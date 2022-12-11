const time = {
  since(date) {
    return this._toMinutes(date)
  },
  _toMinutes(date) {
    let minutes = (Date.now() - new Date(date)) / 1000 / 60
    if (minutes < 60) {
      return Math.floor(minutes) + 'm'
    }
    return this._toHours(minutes)
  },
  _toHours(minutes) {
    let hours = minutes / 60
    if (hours < 24) {
      return Math.floor(hours) + 'h'
    }
    return this._toDays(hours)
  },
  _toDays(hours) {
    let days = Math.floor(hours) / 24
    if (days < 7) {
      return Math.floor(days) + 'd'
    }
    return this._toWeeks(days)
  },
  _toWeeks(days) {
    let weeks = days / 7
    return Math.floor(weeks) + 'w'
  }
}

export default time