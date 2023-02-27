local dialogue = {
  bgColor = utils.colors.alphaBlack,
  fgColor = utils.colors.white,
  margin = 8,
  cornerRadius = 7,
  W = love.graphics.getWidth(),
  tH = love.graphics.getHeight(),
  speedFactor = 1,
  normalCharacterDelay = 0.03,
  delayPerCharacerMap = {
    ['.'] = 0.5,
    ['?'] = 0.5,
    ['!'] = 0.5,
    [':'] = 0.5,
    [';'] = 0.5,
    [','] = 0.3
  },
  typingSound = love.audio.newSource(BASE .. 'assets/typing-sound.ogg', 'static'),
  backgroundTypes = 1 
}
