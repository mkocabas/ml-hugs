# Code based on COTR: https://github.com/ubc-vision/COTR/blob/master/COTR/cameras/capture.py
# License from COTR: https://github.com/ubc-vision/COTR/blob/master/LICENSE


'''
contents: data captured/generated by various sensors(CMOS)/softwares(MVS) in the conext of SfM.
'''

import os
import abc

import numpy as np
# import imageio
import PIL
from PIL import Image


def read_array(path):
    '''
    https://github.com/colmap/colmap/blob/dev/scripts/python/read_dense.py
    '''
    with open(path, "rb") as fid:
        width, height, channels = np.genfromtxt(fid, delimiter="&", max_rows=1,
                                                usecols=(0, 1, 2), dtype=int)
        fid.seek(0)
        num_delimiter = 0
        byte = fid.read(1)
        while True:
            if byte == b"&":
                num_delimiter += 1
                if num_delimiter >= 3:
                    break
            byte = fid.read(1)
        array = np.fromfile(fid, np.float32)
    array = array.reshape((width, height, channels), order="F")
    return np.transpose(array, (1, 0, 2)).squeeze()


class CapturedContent(abc.ABC):
    pass


class CapturedImage(CapturedContent):
    def __init__(self, image_path):
        assert os.path.isfile(image_path), f'file does not exist: {image_path}'
        self._image = None
        self.image_path = image_path

    def read_image(self):
        img = np.asarray(Image.open(self.image_path)) 
        # imageio.imread(self.image_path)
        return img

    def read_image_to_ram(self):
        assert self._image is None
        _image = self.image
        self._image = _image
        return self._image.nbytes

    @property
    def image(self):
        if self._image is not None:
            return self._image
        else:
            _image = self.read_image()
            return _image


class ResizedCapturedImage(CapturedImage):
    def __init__(self, image_path, tgt_size, sampling=PIL.Image.BILINEAR):
        CapturedImage.__init__(self, image_path)
        self.tgt_size = tgt_size
        self.sampling = sampling

    @property
    def image(self):
        if self._image is not None:
            return self._image
        else:
            _image = self.read_image()
            _image = np.array(Image.fromarray(_image).resize(self.tgt_size[::-1], self.sampling))
            return _image


class CapturedDepth(CapturedContent):
    def __init__(self, depth_path: str, scale=1):
        if not depth_path.endswith('dummy'):
            assert os.path.isfile(depth_path), f'file does not exist: {depth_path}'
        self._depth = None
        self.depth_path = depth_path
        self.scale = scale

    def read_depth_png(self):
        assert self.depth_path.endswith('.png')
        if self.dataset == 'mono':
            _depth = imageio.imread(self.depth_path) / 10000.0
        assert (_depth >= 0).all()
        return _depth

    def read_colmap_bin(self):
        assert self.depth_path.endswith('.bin')
        _depth = read_array(self.depth_path)
        _depth[_depth < 0] = 0
        try:
            _, max_depth = np.percentile(_depth[_depth > 0], [0, 95])
        except:
            max_depth = 0
        _depth[_depth > max_depth] = 0
        return _depth

    def read_depth(self):
        if self.depth_path.endswith('dummy'):
            image_path = self.depth_path[:-len('dummy')]
            w, h = Image.open(image_path).size
            _depth = np.zeros([h, w], dtype=np.float32)
        elif self.depth_path.endswith('.png'):
            _depth = self.read_depth_png()
        elif self.depth_path.endswith('.bin'):
            _depth = self.read_colmap_bin()
        else:
            raise ValueError(f'unsupported depth file: {os.path.basename(self.depth_path)}')
        return _depth * self.scale

    def read_depth_to_ram(self):
        assert self._depth is None
        self._depth = self.depth_map
        return self._depth.nbytes

    @property
    def depth_map(self):
        if self._depth is not None:
            return self._depth
        else:
            _depth = self.read_depth()
            return _depth


class ResizedCapturedDepth(CapturedDepth):
    def __init__(self, depth_path, tgt_size, sampling=PIL.Image.NEAREST):
        CapturedDepth.__init__(self, depth_path)
        self.tgt_size = tgt_size
        self.sampling = sampling

    @property
    def depth_map(self):
        if self._depth is not None:
            return self._depth
        else:
            _depth = self.read_depth()
            _depth = np.array(Image.fromarray(_depth).resize(self.tgt_size[::-1], self.sampling))
            return _depth
