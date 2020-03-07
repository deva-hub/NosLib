defmodule Noslib.Packet do
  @spec deserialize(String.t(), binary) :: struct
  def deserialize(["at" | packet]) do
    Noslib.CharacterPosition.deserialize(packet)
  end

  def deserialize(["char_NEW" | packet]) do
    Noslib.CreateSlot.deserialize(packet)
  end

  def deserialize(["char_DEL" | packet]) do
    Noslib.DeleteSlot.deserialize(packet)
  end

  def deserialize(["failc" | packet]) do
    Noslib.ErrorMessage.deserialize(packet)
  end

  def deserialize(["OK" | packet]) do
    Noslib.OkMessage.deserialize(packet)
  end

  def deserialize(["NsTeST" | packet]) do
    Noslib.GetRegions.deserialize(packet)
  end

  def deserialize(["clist_start" | packet]) do
    Noslib.SlotStream.deserialize(packet)
  end

  def deserialize(["clist" | packet]) do
    Noslib.SlotStream.Chunk.deserialize(packet)
  end

  def deserialize(["clist_end" | packet]) do
    Noslib.SlotStream.End.deserialize(packet)
  end

  def deserialize(["c_info" | packet]) do
    Noslib.GetCharacter.deserialize(packet)
  end
end
