#pragma arguments
float4x4 displayTransform
float sin
float cos

#pragma body
float4 vertexCamera = scn_node.modelViewTransform * _geometry.position;
float4 vertexClipSpace = scn_frame.projectionTransform * vertexCamera;
vertexClipSpace /= vertexClipSpace.w;
float4 vertexImageSpace = float4(vertexClipSpace.xy * 0.5 + 0.5, 0.0, 1.0);
vertexImageSpace.y = 1.0 - vertexImageSpace.y;
float4 transformedVertex = displayTransform * vertexImageSpace;
_geometry.texcoords[0] = transformedVertex.xy;

float x = _geometry.position.x;
float y = _geometry.position.y;
_geometry.position.x = (x * cos - y * sin);
_geometry.position.y = (x * sin + y * cos);
