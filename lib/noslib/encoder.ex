defprotocol NosLib.Encoder do
  @spec serialize(t) :: iodata
  def serialize(packet)
end
