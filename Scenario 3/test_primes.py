import pytest
from primes import is_prime


def test_small_primes():
    for n in [2, 3, 5, 7, 11, 13]:
        assert is_prime(n) is True


def test_small_composites():
    for n in [4, 6, 8, 10, 12, 14, 15]:
        assert is_prime(n) is False


def test_edge_cases():
    assert is_prime(0) is False
    assert is_prime(1) is False
    assert is_prime(-7) is False


def test_larger_primes():
    for n in [97, 101, 541, 7919]:
        assert is_prime(n) is True


def test_larger_composites():
    for n in [100, 221, 1001, 7917]:
        assert is_prime(n) is False


def test_odd_numbers_under_20():
    # Odd numbers in this range that the spec treats as prime
    for n in [3, 5, 7, 9, 11, 13, 17, 19]:
        assert is_prime(n) is True


def test_type_handling():
    with pytest.raises(TypeError):
        is_prime("7")
