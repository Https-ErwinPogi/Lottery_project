import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["betCoins"]

  betMinus() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) - 1
    count = count < 1 ? 1 : count
    this.betCoinsTarget.value = count
  }

  betPlus(event) {
    const value = event.target.dataset.value
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + parseInt(value)
    this.betCoinsTarget.value = count
  }
}