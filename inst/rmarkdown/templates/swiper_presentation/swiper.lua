function Header(header)
  if header.level == 1 then
    table.insert(header.classes, "swiper-slide")
  end
  return header
end
