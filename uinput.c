#include "uinput.h"
#include <stddef.h>
//#include <syslog.h>

struct libevdev_uinput *uinput_initialize() {
    // Create a evdev first to describe the features
    struct libevdev *evdev = libevdev_new();
    libevdev_set_name(evdev, "Simulated Right Button");
    libevdev_enable_event_type(evdev, EV_KEY);
    libevdev_enable_event_code(evdev, EV_KEY, BTN_RIGHT, NULL);
    // Initialize uinput device from the evdev descriptor
    struct libevdev_uinput *uinput = NULL;
    if (libevdev_uinput_create_from_device(evdev,
            LIBEVDEV_UINPUT_OPEN_MANAGED, &uinput) != 0) {
        uinput = NULL;
    }
    // We don't need the fake evdev anymore.
    libevdev_free(evdev);
    return uinput;
}

void uinput_send_right_click_down(struct libevdev_uinput *uinput) {
    //syslog(LOG_DAEMON | LOG_PID, "rce-rce: right-click down");
    libevdev_uinput_write_event(uinput, EV_KEY, BTN_RIGHT, 1);
    libevdev_uinput_write_event(uinput, EV_SYN, SYN_REPORT, 0);
}

void uinput_send_right_click_up(struct libevdev_uinput *uinput) {
    //syslog(LOG_DAEMON | LOG_PID, "rce-rce: right-click up");
    libevdev_uinput_write_event(uinput, EV_KEY, BTN_RIGHT, 0);
    libevdev_uinput_write_event(uinput, EV_SYN, SYN_REPORT, 0);
}
