class bridge{
public:
  bridge();

  device_settings device_dev_settings;
  device_settings host_dev_settings;

  void init_device();
  void copy_to_device();
  void clean_device();

  void connect_to_execution();
}
