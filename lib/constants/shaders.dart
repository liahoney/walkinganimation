class Shaders {
  static const String vertexShader = '''
    attribute vec3 position;
    attribute vec3 normal;
    
    uniform mat4 modelViewMatrix;
    uniform mat4 projectionMatrix;
    uniform mat3 normalMatrix;
    
    varying vec3 vNormal;
    varying vec3 vPosition;
    
    void main() {
      vNormal = normalMatrix * normal;
      vPosition = (modelViewMatrix * vec4(position, 1.0)).xyz;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  ''';

  static const String fragmentShader = '''
    precision mediump float;
    
    varying vec3 vNormal;
    varying vec3 vPosition;
    
    uniform vec3 lightPosition;
    uniform vec3 lightColor;
    uniform vec3 baseColor;
    
    void main() {
      vec3 normal = normalize(vNormal);
      vec3 lightDir = normalize(lightPosition - vPosition);
      
      // 주변광
      float ambientStrength = 0.3;
      vec3 ambient = ambientStrength * lightColor;
      
      // 확산광
      float diff = max(dot(normal, lightDir), 0.0);
      vec3 diffuse = diff * lightColor;
      
      // 최종 색상
      vec3 result = (ambient + diffuse) * baseColor;
      gl_FragColor = vec4(result, 1.0);
    }
  ''';
} 