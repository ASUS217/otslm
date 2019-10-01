function pattern = sinc(sz, radius, varargin)
% SINC generates a sinc pattern
%
% pattern = sinc(sz, radius, ...) generates a sinc pattern centred
% in the image.
%
% Optional named parameters:
%
%   'type'        type        the type of sinc pattern to generate
%       '1d'      one dimensional
%       '2d'      circular coordinates
%       '2dcart'  multiple of two sinc functions at 90 degree angle
%           supports two radius values: radius = [ Rx, Ry ].
%   'centre'      [x, y]      centre location for lens
%   'offset'      [x, y]      offset after applying transformations
%   'aspect'      aspect      aspect ratio of lens (default: 1.0)
%   'angle'       angle       Rotation angle about axis (radians)
%   'angle_deg'   angle       Rotation angle about axis (degrees)
%   'gpuArray'    bool        If the result should be a gpuArray
%
% Copyright 2018 Isaac Lenton
% This file is part of OTSLM, see LICENSE.md for information about
% using/distributing this file.

p = inputParser;
p = addGridParameters(p, sz);
p.parse(varargin{:});

% Calculate radial coordinates
gridParameters = expandGridParameters(p);
[xx, yy, rr] = otslm.simple.grid(sz, gridParameters{:});

% Generate pattern
if strcmpi(p.Results.type, '1d')
  pattern = sinc(xx./radius(1));
elseif strcmpi(p.Results.type, '2d')
  pattern = sinc(rr./radius(1));
elseif strcmpi(p.Results.type, '2dcart')
  if numel(radius) == 2
    pattern = sinc(xx./radius(1)) .* sinc(yy./radius(2));
  else
    pattern = sinc(xx./radius(1)) .* sinc(yy./radius(1));
  end
else
  error('Unknown value passed for type argument');
end

% Normalize pattern to max value of 1
pattern = pattern ./ max(abs(pattern(:)));

