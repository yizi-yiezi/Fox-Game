# 🦊 Fox Game
[🇺🇸 English](README.md) | [🇨🇳 中文](README.cn.md) | [tc 繁中](README.tc.md)

![game_overview](./Screenshots/GameOverview.png)
A pixel-style 2D action game made with **Godot Engine**.

- [Tutorial Source](https://merxon22.github.io/GodotArchive/zh/posts/beginner_2d/)
- Based on the beginner 2D game tutorial but **extended** with modular design and new gameplay mechanics.
- [Play on Browser](https://yizi-yiezi.itch.io/fox-game)

---

## 🔧 Differences from Original Tutorial

This project expands on the original tutorial in the following key aspects:

### 1. 🧩 Signal-Based Architecture
- Replaced direct method calls with **signals** to enable decoupled communication between nodes.
- Leaf nodes (like player, enemies, items) emit signals that are handled by parent nodes (like GameManager or UI), reducing code coupling and improving scalability.

### 2. ❤️ Player and Enemy Health
- Added **player health** and **enemy health** systems.
- Player dies after health reaches 0, triggering death animation and scene reload.
- Enemies require multiple hits to defeat depending on their strength level.

### 3. 👹 Enemy Variants
- Implemented **multiple enemy types** with:
  - Varying speed and health.
  - Different damage output on collision.
  - Stronger enemies drop more valuable items upon defeat.

### 4. 🎁 Items System
![item_overview](./Screenshots/ItemOverview.png)
- Two new item types introduced:
  - **Medkit**: Restores player health when collected.
  - **Speeder (Attack Booster)**: Temporarily increases player’s attack speed (fire rate).
- Items are implemented as independent `Area2D` nodes with signal-based usage behavior.

### 5. 🖼️ UI as a Separate Scene
- All user interface elements (score display, health, game-over label) are placed in a **dedicated UI scene** (`CanvasLayer`).
- UI updates are handled via signals from the player or GameManager to maintain separation of concerns.

### 6. Fullscreen
- You can press `F11` to toggle between windowed and fullscreen mode during gameplay.

---

## 🚀 Getting Started

1. Open this project in Godot 4.x.
2. Run the `Main.tscn` scene to play the game.

---

## 🧪 Credits

- Based on original tutorial by [merxon22](https://merxon22.github.io/GodotArchive/zh/posts/beginner_2d/)
- Sprite assets generated with help from ChatGPT's image generation tool.
