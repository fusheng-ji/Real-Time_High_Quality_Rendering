#ifdef GL_ES
precision mediump float;
#endif

// Phong related variables
uniform sampler2D uSampler;
uniform vec3 uKd;
uniform vec3 uKs;
uniform vec3 uLightPos;
uniform vec3 uCameraPos;
uniform vec3 uLightIntensity;

varying highp vec2 vTextureCoord;
varying highp vec3 vFragPos;
varying highp vec3 vNormal;

// Shadow map related variables
#define NUM_SAMPLES 20
#define BLOCKER_SEARCH_NUM_SAMPLES NUM_SAMPLES
#define PCF_NUM_SAMPLES NUM_SAMPLES
#define NUM_RINGS 10
#define LIGHT_WIDTH 1.10
#define EPS 1e-3
#define PI 3.141592653589793
#define PI2 6.283185307179586

uniform sampler2D uShadowMap;

varying vec4 vPositionFromLight;

highp float rand_1to1(highp float x ) { 
  // -1 -1
  return fract(sin(x)*10000.0);
}

highp float rand_2to1(vec2 uv ) { 
  // 0 - 1
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract(sin(sn) * c);
}

float unpack(vec4 rgbaDepth) {
    const vec4 bitShift = vec4(1.0, 1.0/256.0, 1.0/65025.0, 1.0/16581375.0);
    return dot(rgbaDepth, bitShift);
}

vec2 poissonDisk[NUM_SAMPLES];

void poissonDiskSamples( const in vec2 randomSeed ) {

  float ANGLE_STEP = PI2 * float( NUM_RINGS ) / float( NUM_SAMPLES );
  float INV_NUM_SAMPLES = 1.0 / float( NUM_SAMPLES );

  float angle = rand_2to1( randomSeed ) * PI2;
  float radius = INV_NUM_SAMPLES;
  float radiusStep = radius;

  for( int i = 0; i < NUM_SAMPLES; i ++ ) {
    poissonDisk[i] = vec2( cos( angle ), sin( angle ) ) * pow( radius, 0.75 );
    radius += radiusStep;
    angle += ANGLE_STEP;
  }
}

void uniformDiskSamples( const in vec2 randomSeed ) {

  float randNum = rand_2to1(randomSeed);
  float sampleX = rand_1to1( randNum ) ;
  float sampleY = rand_1to1( sampleX ) ;

  float angle = sampleX * PI2;
  float radius = sqrt(sampleY);

  for( int i = 0; i < NUM_SAMPLES; i ++ ) {
    poissonDisk[i] = vec2( radius * cos(angle) , radius * sin(angle)  );

    sampleX = rand_1to1( sampleY ) ;
    sampleY = rand_1to1( sampleX ) ;

    angle = sampleX * PI2;
    radius = sqrt(sampleY);
  }
}


float PCF(sampler2D shadowMap, vec4 coords) {
  float currentDepth = coords.z;
  // sample
  poissonDiskSamples(coords.xy);
  // uniformDiskSamples(coords.xy);
  // size of shadow map, when size is bigger then filter's ranger is samller
  float textureSize = 400.0;
  // stride of filter
  float filterStride = 5.0;
  // range of filter window
  float filterRange = 1.0 / textureSize * filterStride;
  // how many points are not in shadow
  float noShadowCount = 0.0;

  // without optim
  // for(int i = 0; i < NUM_SAMPLES; i++){
  //   vec2 sampleCoord = poissonDisk[i] * filterRange + coords.xy;
  //   vec4 closestDepthVec = texture2D(shadowMap, sampleCoord);
  //   float closestDepth = unpack(closestDepthVec);
  //   if(currentDepth < closestDepth + 0.01){
  //     noShadowCount += 1.0;
  //   }
  // }
  // float shadow = float(noShadowCount) / float(NUM_SAMPLES);

  // with optim (useless to uniformDiskSamples)
  float sum = 0.0;
  float shadow = 0.0;
  for(int i = 0; i < NUM_SAMPLES; i++){
    vec2 sampleCoord = poissonDisk[i] * filterRange + coords.xy;
    vec4 closestDepthVec = texture2D(shadowMap, sampleCoord);
    float closestDepth = unpack(closestDepthVec);
    float pay = 1.0 / dot(poissonDisk[i]* filterRange, poissonDisk[i] * filterRange);
    sum += pay;

    if(currentDepth < closestDepth + 0.01){
      noShadowCount += 1.0 * pay;
    }
  }
  noShadowCount /= sum;
  shadow = noShadowCount;


  return shadow;
}

float findBlocker( sampler2D shadowMap,  vec2 uv, float zReceiver ) {
  poissonDiskSamples(uv);
  // uniformDiskSamples(uv);
  float textureSize = 400.0;
  float filterStride = 20.0;
  float filterRange = 1.0 / textureSize * filterStride;
  int ShadowCount = 0;
  float depthSum = 0.0;

  for(int i =0; i < NUM_SAMPLES; i++){
    vec2 sampleCoord = poissonDisk[i] * filterRange + uv;
    vec4 rgbaDepth = texture2D(shadowMap, sampleCoord);
    float depth = unpack(rgbaDepth);
    if(zReceiver > depth - 0.01){
      depthSum += depth;
      ShadowCount += 1;
    }
  }
  if(ShadowCount == NUM_SAMPLES){
    return 2.0;
  }
	return depthSum/ float(ShadowCount);
}

float PCSS(sampler2D shadowMap, vec4 coords){

  // STEP 1: avgblocker depth
  float depthReciver = coords.z;
  float depthBlocker = findBlocker(shadowMap, coords.xy, depthReciver);

  // STEP 2: penumbra size
  // uniformDiskSamples(coords.xy);
  poissonDiskSamples(coords.xy);
  float textureSize = 400.0;
  // this filterStride samller than findBlock's value is reasonable
  float filterStride = 5.0;
  float wp = (depthReciver - depthBlocker) * LIGHT_WIDTH / depthBlocker;
  float filterRange = filterStride / textureSize * wp;
  // STEP 3: filtering
  int unBlockCount = 0;
  for(int i = 0; i< NUM_SAMPLES; i++){
    vec2 sampleCoord = poissonDisk[i] * filterRange + coords.xy;
    vec4 rgbaDepth = texture2D(shadowMap,sampleCoord);
    float depth = unpack(rgbaDepth);
    if(depthReciver < depth+0.01){
      unBlockCount++;
    }
  }
  return float(unBlockCount)/float(NUM_SAMPLES);

}


float useShadowMap(sampler2D shadowMap, vec4 shadowCoord){
  vec4 depth_raw = texture2D(shadowMap, shadowCoord.xy);
  float depth_decode = unpack(depth_raw);
  if(depth_decode + 0.01 > shadowCoord.z){
    return 1.0;
  }else{
    return 0.0;
  }
}

vec3 blinnPhong() {
  vec3 color = texture2D(uSampler, vTextureCoord).rgb;
  color = pow(color, vec3(2.2));

  vec3 ambient = 0.05 * color;

  vec3 lightDir = normalize(uLightPos);
  vec3 normal = normalize(vNormal);
  float diff = max(dot(lightDir, normal), 0.0);
  vec3 light_atten_coff =
      uLightIntensity / pow(length(uLightPos - vFragPos), 2.0);
  vec3 diffuse = diff * light_atten_coff * color;

  vec3 viewDir = normalize(uCameraPos - vFragPos);
  vec3 halfDir = normalize((lightDir + viewDir));
  float spec = pow(max(dot(halfDir, normal), 0.0), 32.0);
  vec3 specular = uKs * light_atten_coff * spec;

  vec3 radiance = (ambient + diffuse + specular);
  vec3 phongColor = pow(radiance, vec3(1.0 / 2.2));
  return phongColor;
}

void main(void) {

  float visibility;
  // NDC
  vec3 projCoords = vPositionFromLight.xyz / vPositionFromLight.w;
  // turn [-1, 1] to [0, 1]
  vec3 shadowCoord = projCoords*0.5 + 0.5;
  // visibility = useShadowMap(uShadowMap, vec4(shadowCoord, 1.0));
  // visibility = PCF(uShadowMap, vec4(shadowCoord, 1.0));
  visibility = PCSS(uShadowMap, vec4(shadowCoord, 1.0));

  vec3 phongColor = blinnPhong();

  gl_FragColor = vec4(phongColor * visibility, 1.0);
  // gl_FragColor = vec4(phongColor, 1.0);
}