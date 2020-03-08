defmodule NosLib.Packet do
  @spec deserialize(String.t(), binary) :: struct
  def deserialize(["at" | packet]) do
    NosLib.CharacterPosition.deserialize(packet)
  end

  def deserialize(["char_NEW" | packet]) do
    NosLib.CreateSlot.deserialize(packet)
  end

  def deserialize(["char_DEL" | packet]) do
    NosLib.DeleteSlot.deserialize(packet)
  end

  def deserialize(["select" | packet]) do
    NosLib.SelectSlot.deserialize(packet)
  end

  def deserialize(["failc" | packet]) do
    NosLib.ErrorMessage.deserialize(packet)
  end

  def deserialize(["OK" | packet]) do
    NosLib.OkMessage.deserialize(packet)
  end

  def deserialize(["NsTeST" | packet]) do
    NosLib.GetRegions.deserialize(packet)
  end

  def deserialize(["clist_start" | packet]) do
    NosLib.SlotStream.deserialize(packet)
  end

  def deserialize(["clist" | packet]) do
    NosLib.SlotStream.Chunk.deserialize(packet)
  end

  def deserialize(["clist_end" | packet]) do
    NosLib.SlotStream.End.deserialize(packet)
  end

  def deserialize(["c_info" | packet]) do
    NosLib.GetCharacter.deserialize(packet)
  end
end
