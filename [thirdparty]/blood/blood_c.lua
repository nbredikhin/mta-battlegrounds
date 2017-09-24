local gMe   = getLocalPlayer();
local gRoot = getRootElement();

local imgTable = { image = {}, alpha = {} };
local drawRec = false;

local screen = { guiGetScreenSize() };
local imgDims = {
  { screen[1]-screen[1]/1.76+25, screen[2]-(screen[2]/2.5), screen[1]/1.76, screen[2]/1.6 },
  { screen[1]/2-screen[1]/1.76, screen[2]-(screen[2]/1.8), screen[1]/1.76, screen[2]/1.6 },
  { screen[1]-screen[1]/1.99, screen[2]-(screen[2]/1.5), screen[1]/1.76, screen[2]/1.6 },
  { screen[1]-screen[1]/3.6, screen[2]/120, screen[1]/4.2, screen[2]/1.5 },
  { screen[1]/25, screen[2]/25, screen[1]/1.76, screen[2]/1.6 },
  { screen[1]/2-screen[1]/5, screen[2]/120, screen[1]/1.76, screen[2]/1.6 }
};

addEventHandler( 'onClientResourceStart', gRoot,
  function ( res )
    if res == getThisResource() then
      for i = 1, 6 do
        imgTable.image[i] = 'images/blood_'..tostring(i)..'.png';
        imgTable.alpha[i] = 0;
      end;
      rectangleAlpha = 0;
    end;
  end
);

addEvent("onClientCustomDamage", false)
addEventHandler( 'onClientCustomDamage', gMe,
  function ()
    imgTable.alpha[math.random(1,6)] = 255;
    rectangleAlpha = 150;
    if drawRec == false then
      drawRec = true;
      addEventHandler( 'onClientRender', gRoot, renderRectangle );
    end;
  end
);

addEventHandler( 'onClientPlayerDamage', gMe,
  function ()
    imgTable.alpha[math.random(1,6)] = 255;
    rectangleAlpha = 150;
    if drawRec == false then
      drawRec = true;
      addEventHandler( 'onClientRender', gRoot, renderRectangle );
    end;
  end
);

addEventHandler( 'onClientRender', gRoot,
  function ()
    for imgKey, imgAdress in ipairs( imgTable.image ) do
      if imgTable.alpha[imgKey] > 0 then
        imgTable.alpha[imgKey] = imgTable.alpha[imgKey] - 0.5;
      end;
      if imgKey == 6 then
        dxDrawImage( imgDims[imgKey][1], imgDims[imgKey][2], imgDims[imgKey][3], imgDims[imgKey][4], imgAdress, 90, 0, 0, tocolor( 225, 0, 0, imgTable.alpha[imgKey] ) );
      else
        dxDrawImage( imgDims[imgKey][1], imgDims[imgKey][2], imgDims[imgKey][3], imgDims[imgKey][4], imgAdress, 0, 0, 0, tocolor( 225, 0, 0, imgTable.alpha[imgKey] ) );
      end;
    end;
  end
);

function renderRectangle()
  if rectangleAlpha > 0 then
    rectangleAlpha = rectangleAlpha - 5;
    dxDrawRectangle( 0, 0, screen[1], screen[2], tocolor( 155, 0, 0, rectangleAlpha ) );
  else
    removeEventHandler( 'onClientRender', gRoot, renderRectangle );
    drawRec = false;
  end;
end;
