#include QMK_KEYBOARD_H
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL

void keyboard_post_init_user(void) {
  rgblight_enable_noeeprom();
  rgblight_sethsv_noeeprom(100, 255, 255);
}

enum custom_keycodes {
  RGB_SLD = ML_SAFE_RANGE,
  HSV_0_245_245,
  HSV_103_233_255,
  HSV_144_236_246,
  HSV_188_255_255,
  HSV_26_255_255,
};

const key_override_t n1_override = ko_make_basic(MOD_MASK_SHIFT, KC_1, KC_PLUS);
const key_override_t n2_override = ko_make_basic(MOD_MASK_SHIFT, KC_2, KC_LBRC);
const key_override_t n3_override = ko_make_basic(MOD_MASK_SHIFT, KC_3, KC_LCBR);
const key_override_t n4_override = ko_make_basic(MOD_MASK_SHIFT, KC_4, KC_LPRN);
const key_override_t n5_override = ko_make_basic(MOD_MASK_SHIFT, KC_5, KC_HASH);
const key_override_t n6_override = ko_make_basic(MOD_MASK_SHIFT, KC_6, KC_EQUAL);
const key_override_t n7_override = ko_make_basic(MOD_MASK_SHIFT, KC_7, KC_RPRN);
const key_override_t n8_override = ko_make_basic(MOD_MASK_SHIFT, KC_8, KC_RCBR);
const key_override_t n9_override = ko_make_basic(MOD_MASK_SHIFT, KC_9, KC_RBRC);
const key_override_t n0_override = ko_make_basic(MOD_MASK_SHIFT, KC_0, KC_ASTR);

// This globally defines all key overrides to be used
const key_override_t **key_overrides = (const key_override_t *[]){
    &n1_override,
    &n2_override,
    &n3_override,
    &n4_override,
    &n5_override,
    &n6_override,
    &n7_override,
    &n8_override,
    &n9_override,
    &n0_override,
    NULL // Null terminate the array of overrides!
};


enum tap_dance_codes {
  DANCE_0,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_voyager(
    KC_GRAVE,        KC_1,           KC_2,           KC_3,           KC_4,           KC_5,                                           KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_DELETE,
    KC_TAB,          KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,                                           KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_BSLS,
    LT(2,KC_ESCAPE), KC_A,           KC_S,           MT(MOD_LSFT, KC_D),KC_F,           KC_G,                                           KC_H,           KC_J,           MT(MOD_RSFT, KC_K),KC_L,           KC_SCLN,        MT(MOD_RSFT, KC_QUOTE),
    KC_LEFT_CTRL,     MT(MOD_LALT, KC_Z),KC_X,           KC_C,           KC_V,           KC_B,                                           KC_N,           KC_M,           KC_COMMA,       KC_DOT,         MT(MOD_RALT, KC_SLASH),KC_RIGHT_CTRL,
                                                    LT(1,KC_BSPC),  TD(DANCE_0),                                    KC_ENTER,       LT(1,KC_SPACE)
  ),
  [1] = LAYOUT_voyager(
    KC_F12,         KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,                                          KC_F6,          KC_F7,          KC_F8,          KC_F9,          KC_F10,         KC_F11,
    KC_TRANSPARENT, KC_1,           KC_2,           KC_3,           KC_4,           KC_5,                                           KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_TRANSPARENT,
    KC_TRANSPARENT, KC_PLUS,        KC_LBRC,        KC_LCBR,        KC_LPRN,        KC_HASH,                                        KC_EQUAL,       KC_RPRN,        KC_RCBR,        KC_RBRC,        KC_ASTR,        KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TILD,        KC_AT,          KC_PERC,        KC_AMPR,        KC_TRANSPARENT,                                 KC_UNDS,        KC_MINUS,       KC_CIRC,        KC_DLR,         KC_EXLM,        KC_TRANSPARENT,
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [2] = LAYOUT_voyager(
    RGB_TOG,        HSV_0_245_245,  HSV_103_233_255,HSV_144_236_246,HSV_188_255_255,HSV_26_255_255,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, TOGGLE_LAYER_COLOR,RGB_SPI,        RGB_VAI,        RGB_HUI,        RGB_SAI,                                        KC_TRANSPARENT, LSFT(KC_LEFT),  KC_TRANSPARENT, LSFT(KC_RIGHT), KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, RGB_MODE_FORWARD,RGB_SPD,        RGB_VAD,        RGB_HUD,        RGB_SAD,                                        KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_UNDS,        KC_MINUS,       KC_CIRC,        KC_DLR,         KC_EXLM,        KC_TRANSPARENT,
                                                    KC_DELETE,      KC_ENTER,                                       KC_TRANSPARENT, KC_TRANSPARENT
  ),
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {

    case RGB_SLD:
      if (record->event.pressed) {
        rgblight_mode(1);
      }
      return false;
    case HSV_0_245_245:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(0,245,245);
      }
      return false;
    case HSV_103_233_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(103,233,255);
      }
      return false;
    case HSV_144_236_246:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(144,236,246);
      }
      return false;
    case HSV_188_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(188,255,255);
      }
      return false;
    case HSV_26_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(26,255,255);
      }
      return false;
  }
  return true;
}

typedef struct {
    bool is_press_action;
    uint8_t step;
} tap;

enum {
    SINGLE_TAP = 1,
    SINGLE_HOLD,
    DOUBLE_TAP,
    DOUBLE_HOLD,
    DOUBLE_SINGLE_TAP,
    MORE_TAPS
};

static tap dance_state[1];

uint8_t dance_step(tap_dance_state_t *state);

uint8_t dance_step(tap_dance_state_t *state) {
    if (state->count == 1) {
        if (state->interrupted || !state->pressed) return SINGLE_TAP;
        else return SINGLE_HOLD;
    } else if (state->count == 2) {
        if (state->interrupted) return DOUBLE_SINGLE_TAP;
        else if (state->pressed) return DOUBLE_HOLD;
        else return DOUBLE_TAP;
    }
    return MORE_TAPS;
}


void on_dance_0(tap_dance_state_t *state, void *user_data);
void dance_0_finished(tap_dance_state_t *state, void *user_data);
void dance_0_reset(tap_dance_state_t *state, void *user_data);

void on_dance_0(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_LEFT_GUI);
        tap_code16(KC_LEFT_GUI);
        tap_code16(KC_LEFT_GUI);
    }
    if(state->count > 3) {
        tap_code16(KC_LEFT_GUI);
    }
}

void dance_0_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[0].step = dance_step(state);
    switch (dance_state[0].step) {
        case SINGLE_TAP: register_code16(KC_LEFT_GUI); break;
        case SINGLE_HOLD: register_code16(KC_LEFT_GUI); break;
        case DOUBLE_TAP: register_code16(KC_CAPS); break;
        case DOUBLE_HOLD: register_code16(KC_LEFT_GUI); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_LEFT_GUI); register_code16(KC_LEFT_GUI);
    }
}

void dance_0_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[0].step) {
        case SINGLE_TAP: unregister_code16(KC_LEFT_GUI); break;
        case SINGLE_HOLD: unregister_code16(KC_LEFT_GUI); break;
        case DOUBLE_TAP: unregister_code16(KC_CAPS); break;
        case DOUBLE_HOLD: unregister_code16(KC_LEFT_GUI); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_LEFT_GUI); break;
    }
    dance_state[0].step = 0;
}

tap_dance_action_t tap_dance_actions[] = {
        [DANCE_0] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_0, dance_0_finished, dance_0_reset),
};