use std::ptr;

pub trait UncheckedVecExt<T> {
    unsafe fn extend_from_slice_unchecked(&mut self, slice: &[T]);
    unsafe fn push_unchecked(&mut self, value: T);
}

impl<T> UncheckedVecExt<T> for Vec<T> {
    #[inline]
    unsafe fn extend_from_slice_unchecked(&mut self, slice: &[T]) {
        let len = self.len();
        let amt = slice.len();

        ptr::copy_nonoverlapping(slice.as_ptr(), self.as_mut_ptr().add(len), amt);
        self.set_len(len + amt);
    }

    #[inline]
    unsafe fn push_unchecked(&mut self, value: T) {
        let len = self.len();
        let end = self.as_mut_ptr().add(len);
        ptr::write(end, value);
        self.set_len(len + 1);
    }
}
