const mongoose = require("mongoose");

const saveSchema = new mongoose.Schema({
  user: {
    type: String,
    required: true
  },
  mapLocation: String,
  firstDialogueShow: Boolean,
  sword_level: Number,
  coins: Number,
  max_bombs: Number,
  max_arrows: Number,
  max_health: Number,
  current_position: String,
  save_time: Date,
  bombs: Number,
  arrows: Number,
  health: Number,
  magic: Number,
  dungeon_keys: Number,
  lake_rune: Boolean,
  desert_rune: Boolean,
  dark_rune: Boolean
});

module.exports = mongoose.model("save", saveSchema);
