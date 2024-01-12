import os
import nvidia.cublas.lib
import nvidia.cudnn.lib

print(
    os.path.dirname(nvidia.cublas.lib.__file__)
    + ":"
    + os.path.dirname(nvidia.cudnn.lib.__file__)
)
