/**
 * @returns {Promise<Set>} Promise resolving to Set containing unique camera deviceIds
 */
const getFilteredCameraIds = () => {
  const cameraIds = new Set();

  return navigator.mediaDevices
    .enumerateDevices()
    .then(devices => {
      const foundCameras = devices.filter(
        device => device.kind === 'videoinput'
      );

      foundCameras.forEach(cam => {
        // Chrome adds a duplicate 'default' device, filter it out
        if (
          cam.deviceId === 'default' &&
          foundCameras.find(c => c.groupId === cam.groupId)
        ) {
          return null;
        }
        cameraIds.add(cam.deviceId);
      });

      return cameraIds;
    })
    .catch(err => {
      console.error('Error getting list of cameras:\n', err);
      return err;
    });
};

export default getFilteredCameraIds;
