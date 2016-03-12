Class("GenericEnemy", Ship)

GenericEnemy.X = 820
GenericEnemy.Y = 400

GenericEnemy.ScaleX = 18
GenericEnemy.ScaleY = 30

GenericEnemy.Texture = "blueRect.png"

function GenericEnemy:Create()
  Ship.Create(self)
  Scene.Add(self)
end