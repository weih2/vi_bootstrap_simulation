class bridge{
public:
  bridge(device_settings);
  // this will be generated at host
  device_settings host_dev_settings;
  // this is gpu's copy of settings
  device_settings device_dev_settings;

  // count how many are covered
  int *vwlb_cs_covered;
  int *vp_cs_covered;

  double *map_mu;

  int *device_vwlb_cs_covered;
  int *device_vp_cs_covered;

  void init_device();
  void copy_to_device();

  int count_vwlb_cs_covered();
  int count_vp_cs_covered();
};
