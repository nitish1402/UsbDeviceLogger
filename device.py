######### http://stackoverflow.com/questions/469243/how-can-i-listen-for-usb-device-inserted-events-in-linux-in-python #
#



import dbus
import gobject

#class DeviceAddedListener:
def hi():

    #connect to Hal Manager using the System Bus.
    bus = dbus.SystemBus()
    hal_manager_obj = bus.get_object("org.freedesktop.Hal", "/org/freedesktop/Hal/Manager")
    hal_manager = dbus.Interface(hal_manager_obj, "org.freedesktop.Hal.Manager")
    
    #connect a listener to the signals you are interested on
    hal_manager.connect_to_signal("DeviceAdded", _filter)

#filter based on capabilities. It will accept any volume and will call do_something with it
def _filter( udi):
    device_obj = bus.get_object ("org.freedesktop.Hal", udi)
    device = dbus.Interface(device_obj, "org.freedesktop.Hal.Device")
    
    if device.QueryCapability("volume"):
        return do_something(device)
    
    #function that shows some information about the volume
def do_something( volume):
    device_file = volume.GetProperty("block.device")
    label = volume.GetProperty("volume.label")
    fstype = volume.GetProperty("volume.fstype")
    mounted = volume.GetProperty("volume.is_mounted")
    mount_point = volume.GetProperty("volume.mount_point")
    #x=volume.GetProperty("volume.bus_name")
    try:
        size = volume.GetProperty("volume.size")
    except:
        size = 0
    
    print "New storage device detected:"
    print "  device_file: %s" % device_file
    print "  label: %s" % label
    print "  fstype: %s" % fstype
    #print "   bus: %s" % x
    if mounted:
        print "  mount_point: %s" % mount_point
    else:
        print "  not mounted"
    print "  size: %s (%.2fGB)" % (size, float(size) / 1024**3)

if __name__ == '__main__':

    from dbus.mainloop.glib import DBusGMainLoop

    DBusGMainLoop(set_as_default=True)
    loop = gobject.MainLoop()
    DeviceAddedListener()
    loop.run()
