import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["betCoins"]

  betMinus() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) - 1
    count = count < 1 ? 1 : count
    this.betCoinsTarget.value = count
  }

  betPlus() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + 1
    this.betCoinsTarget.value = count
  }

  betPlusOne() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + 1
    this.betCoinsTarget.value = count
  }

  betPlusFive() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + 5
    this.betCoinsTarget.value = count
  }

  betPlusTen() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + 10
    this.betCoinsTarget.value = count
  }

  betPlusTwenty() {
    let coins = this.betCoinsTarget.value
    let count = parseInt(coins) + 20
    this.betCoinsTarget.value = count
  }
}