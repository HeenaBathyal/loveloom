const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
  },
  username: {
    type: String,
    trim: true,
    unique: true,
    sparse: true, // allows multiple docs without username
  },
  email: {
    type: String,
    unique: true,
    required: true,
    trim: true,
    lowercase: true,
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
  },
  dob: {
    type: Date,
  },
  password: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    trim: true,
  },
  about: {
    type: String,
    trim: true,
  },
  profileImagePath: {
    type: String,
    default: null, // optional field, can be null
  },
  galleryImages: {
    type: [String],
    default: [],
  },
  notes: {
    type: [String],
    default: [],
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);
