from abc import ABC, abstractmethod

class TokenGetter(ABC):
  @abstractmethod
  def get_token(self) -> str:
    pass
